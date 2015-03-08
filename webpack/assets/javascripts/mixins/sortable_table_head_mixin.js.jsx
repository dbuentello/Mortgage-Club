/**
 * @jsx React.DOM
 */

var SortableTableHead = {
  handleSort: function(sort, direction, currentSort, currentDirection, event) {
    event.stopPropagation();

    if (!sort) {
      return;
    }

    if (!direction) {
      direction = (currentDirection == 'asc' && currentSort == sort ? 'desc' : 'asc');
    }

    if (typeof this.onSortChange == 'function') {
      this.onSortChange({
        sort: sort,
        direction: direction
      });
    }
  },

  renderSortableTableHead: function(sort, direction) {
    return (
      <tr>
        {this.fields.map(function (field) {
          var activeSort = (sort == field.value);

          return (
            <th key={field.name}
              className={"plm" + (field.value ? ' clickable' : '') + (field.extraClasses ? ' ' + field.extraClasses + ' ' : '')}
              style={field.style || null}
              onClick={this.handleSort.bind(this, field.value, null, sort, direction)}>
              <a>
                {field.name}
                {field.value ? <span className={'sort-actions prn ' + (activeSort ? 'active' :'inactive')}>
                  <span className="dropup" style={{display: activeSort && direction == 'desc' ? 'none' : null}}>
                    <span className="caret caret-top" onClick={this.handleSort.bind(this, field.value, 'asc', sort, direction)}>
                    </span>
                  </span>
                  <span className="caret caret-bottom"
                    style={{display: activeSort && direction == 'asc' ? 'none' : null}}
                    onClick={this.handleSort.bind(this, field.value, 'desc', sort, direction)}>
                  </span>
                </span> : ''}
              </a>
            </th>
          );
        }, this)}
      </tr>
    );
  }
};

module.exports = SortableTableHead;
