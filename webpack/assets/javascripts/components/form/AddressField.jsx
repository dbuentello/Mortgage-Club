var React = require('react/addons');
var _ = require('lodash');

//var TextFocusMixin = require('mixins/text_focus_mixin');

function getFormattedAddress(addressable) {
  if (!addressable) {
    return 'Unknown';
  }

  var address = _.compact([
    addressable.street_address,
    addressable.street_address2,
    addressable.city,
    addressable.state,
    addressable.country,
    addressable.zip
  ]).join(', ');

  return (!address) ? addressable.autocomplete_text : address;
}

/**
 * # AddressAutocompleteMixin
 * @requires google maps api
 */
var AddressAutocompleteMixin = {
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
      types: ['geocode']
    });

    this.listeners.push(google.maps.event.addListener(this.autocomplete, 'place_changed', function() {
      this.handleAddressChange(el);
    }.bind(this)));

    this.listeners.push(google.maps.event.addDomListener(el, 'keydown', function (e) {
      if (e.keyCode == 13) {
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
  },

  handleChange: function(event) {
    var change = {};
    if (typeof this.props.onChange == 'function') {
      change[this.props.keyName] = {
        street_address: null,
        street_address2: null,
        city: null,
        state: null,
        zip: null,
        country: null,
        autocomplete_text: event.target.value
      };

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
      country: address.country,
      autocomplete_text: el.value
    });

    if (typeof this.props.onChange == 'function') {
      this.props.onChange(change);
    }
  }

};

/**
 * AddressField is a text field that has google autocomplete interface built-in.
 */
var AddressField = React.createClass({
  mixins: [AddressAutocompleteMixin],

  propTypes: {
    editable: React.PropTypes.bool, // determines if component should show the input box or the static text
    label: React.PropTypes.string, // field label
    hidden: React.PropTypes.bool, // the entire component will be hidden if this is true

    // if onChange is provided, when user changes the address, the method will be invoked with
    // an object `change` passed in as the single argument. The `change` object is in the format
    // {[@keyName]: [address]} where @keyName is from the props and `address` is the updated address object.
    // The provided @address object will be extended with the following properties:
    // street_address, street_address2, city, state, zip, country, autocomplete_text
    onChange: React.PropTypes.func,
    keyName: React.PropTypes.string,
    // if @address object is provided, the value of `autocomplete_text` will be used as
    // the component's default initial value.
    address: React.PropTypes.objectOf(React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.number
    ])),
  },

  render: function() {
    var address = this.props.address,
        val = address ? getFormattedAddress(address) : '';

    return (
      <div className={this.props.hidden? 'hidden' : null}>
        <label className="col-xs-12 pan" style={{'display': this.props.editable ? null : 'none'}}>
          <span className={this.props.label ? 'mrs' : null}>{this.props.label}</span>
          <input className="form-control input-sm" type="text" value={val} onFocus={this.handleFocus} onChange={this.handleChange} />
        </label>
        <div style={{'display': this.props.editable ? 'none' : null}}>
          <label className="col-xs-12 pan">
            <span className={this.props.label ? 'mrs' : null}>{this.props.label}</span>
          </label>
          <p className="form-control-static col-xs-12 pan">{val}</p>
        </div>
      </div>
    );
  }
});

module.exports = AddressField;
