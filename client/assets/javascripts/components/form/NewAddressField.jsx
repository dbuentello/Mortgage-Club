var React = require('react/addons');
var _ = require('lodash');

var TextFocusMixin = require('mixins/TextFocusMixin');
var TextField = require('./TextField');
var ValidationField = require('./ValidationField');
function getFormattedAddress(addressable) {
  if (!addressable) {
    return 'Unknown';
  }

  var address = _.compact([
    addressable.street_address,
    addressable.street_address2,
    addressable.city,
    addressable.state
  ]).join(', ');

  if(address && addressable.zip) {
    address += " " + addressable.zip;
    return address;
  }
  else {
    return addressable.full_text;
  }


  return (!address) ? addressable.full_text : address;
}

/**
 * AddressField is a text field that has google autocomplete interface built-in.
 */
var AddressField = React.createClass({
  mixins: [TextFocusMixin],

  propTypes: {
    editable: React.PropTypes.bool, // determines if component should show the input box or the static text
    label: React.PropTypes.string, // field label
    hidden: React.PropTypes.bool, // the entire component will be hidden if this is true

    // if onChange is provided, when user changes the address, the method will be invoked with
    // an object `change` passed in as the single argument. The `change` object is in the format
    // {[@keyName]: [address]} where @keyName is from the props and `address` is the updated address object.
    // The provided @address object will be extended with the following properties:
    // street_address, street_address2, city, state, zip, country, full_text
    onChange: React.PropTypes.func,
    keyName: React.PropTypes.string,
    // if @address object is provided, the value of `full_text` will be used as
    // the component's default initial value.
    address: React.PropTypes.objectOf(React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.number
    ])),

    placeholder: React.PropTypes.string
  },

  getDefaultProps: function() {
    return {
      placeholder: ''
    };
  },

  getInitialState: function() {
    return {
      showFullForm: false
    };
  },

  listeners: [],

  componentFields: {
    street_number: 'short_name',
    route: 'long_name',
    locality: 'long_name',
    administrative_area_level_1: 'short_name',
    country: 'long_name',
    postal_code: 'short_name'
  },

  initAutocomplete: function(el) {
    if (typeof google == 'undefined') {
      return;
    }

    // Create the autocomplete object, restricting the search
    // to geographical location types.
    this.autocomplete = new google.maps.places.Autocomplete(el, {
      types: ['geocode'],
      componentRestrictions: {country: 'us'}
    });

    this.listeners.push(google.maps.event.addListener(this.autocomplete, 'place_changed', function() {
      this.handleAddressChange(el);
    }.bind(this)));

    this.listeners.push(google.maps.event.addDomListener(el, 'keydown', function (e) {
      if (e.keyCode == 13) {
        // google.maps.event.trigger(this.autocomplete, 'place_changed');

        if (e.preventDefault) {
          e.preventDefault();
        } else {
          e.cancelBubble = true;
          e.returnValue = false;
        }
      }
    }));
  },

  componentDidMount: function() {
    this.initAutocomplete(this.getDOMNode().getElementsByTagName('input')[0]);
  },

  componentWillUnmount: function() {
    _.each(this.listeners, function (listener) {
      google.maps.event.removeListener(listener);
    });
    document.body.removeEventListener('click', this.handleClickAway);
  },

  handleChange: function(event) {
    var change = {},
        text = event.target.value,
        address;

    if (typeof this.props.onChange == 'function') {
      address = {
        street_address: null,
        street_address2: null,
        city: null,
        state: null,
        zip: null,
        full_text: text
      };

      if (!text) {
        change[this.props.keyName] = null;
      } else {
        if (this.props.address && this.props.address.id) {
          address.id = address.id;
        }

        change[this.props.keyName] = address;
      }

      this.props.onChange(change);
    }
  },

  handleAddressChange: function(el) {
    var place = this.autocomplete.getPlace(),
        address = {
          value: el.value
        },
        change = {},
        addressType, i, val;

    // prevent error Uncaught TypeError
    if (typeof place.address_components == 'undefined') {
      return;
    }

    // Get each component of the address from the place details
    // and set the corresponding field in the state.
    for (i = 0; i < place.address_components.length; i++) {
      addressType = place.address_components[i].types[0];

      if (this.componentFields[addressType]) {
        val = place.address_components[i][this.componentFields[addressType]];
        address[addressType] = val;
      }
    }

    if (address.street_number && address.route) {
      address.street_address = address.street_number + ' ' + address.route;
    } else {
      address.street_address = el.value.split(',')[0];
    }

    change[this.props.keyName] = _.extend(this.props.address || {}, {
      street_address: address.street_address,
      street_address2: '',
      city: address.locality,
      state: address.administrative_area_level_1,
      zip: address.postal_code,
      full_text: el.value
    });

    if (typeof this.props.onChange == 'function') {
      this.props.onChange(change);
    }
  },

  handleFormChange: function(fieldChange) {
    var change = {};

    if (typeof this.props.onChange == 'function') {
      change[this.props.keyName] = _.extend(this.props.address, fieldChange);
      this.props.onChange(change);
    }
  },

  render: function() {
    var address = this.props.address || {},
        val = getFormattedAddress(address) || '',
        requiredMessage = this.props.requiredMessage || "This field is required";

    var disabled = this.props.editMode === false ? "disabled" : null;

    return (
      <div>
        <h6>{this.props.label}</h6>
        {
          this.props.helpText
          ?
            <p className="helpful-text">
              <img src="/icons/info.png" />{this.props.helpText}
            </p>
          :
            null
        }
        <input disabled={disabled} className="form-control" type="text"
          value={val} placeholder={this.props.placeholder}
          onFocus={this.handleFocus} onBlur={this.handleBlur} onChange={this.handleChange} id={this.props.keyName} name={this.props.label}/>
        <img src="/icons/address.png" alt="title"/>
        <ValidationField id={this.props.keyName} activateRequiredField={this.props.activateRequiredField} value={address} title={requiredMessage} validationTypes={this.props.validationTypes}/>
      </div>
    );
  },

  handleBlur: function() {
    if (!this.props.address) {
      return;
    }
    setTimeout(_.bind(this.verifyCompletion, this), 200);
  },

  verifyCompletion: function() {
    var address = this.props.address;

    if (!address.state || !address.zip || !address.city || !address.street_address) {
      if (!address.street_address) {
        address.street_address = address.full_text;
      }
      // this.toggleDetailForm(true);
    }
  },

  handleIconClick: function(event) {
    if (event) {
      event.preventDefault();
      event.stopPropagation();
    }
    // this.toggleDetailForm();
  },

  toggleDetailForm: function(show) {
    show = (typeof show == 'undefined') ? !this.state.showFullForm : show;
    this.setState({showFullForm: show}, function() {
      if (show) {
        $(this.refs.detailForm.getDOMNode()).find('input').first().focus();
        $(this.refs.detailForm.getDOMNode()).on('click', this.stopPropagation);
        document.body.addEventListener('click', this.handleClickAway);
      } else {
        document.body.removeEventListener('click', this.handleClickAway);
      }
    });
  },

  handleClickAway: function() {
    // this.toggleDetailForm(false);
  },

  stopPropagation: function(event) {
    event.stopPropagation();
  }
});


module.exports = AddressField;
