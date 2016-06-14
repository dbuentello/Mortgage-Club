/**
 * Component: Paging
 */
var _ = require("lodash");
var React = require("react/addons");

var PaginationSection = React.createClass({

  render: function(){

    var pageArray = [];
    for(var idx = 0; idx < this.props.totalPages; idx++) {
      pageArray.push(idx);
    }
    var currentPage = this.props.currentPage;

    return (
        <ul className="pagination">
          {
            _.map(pageArray, function(item){
              return(<li key={item} className={currentPage == parseInt(item+1) ? "active" : null}>
                <a href={"/mortgage_data?page=" + parseInt(item+1)}>{ item + 1}</a>
                </li>
              )
            }, this)
        }

        </ul>
      );
  }
});
module.exports = PaginationSection;