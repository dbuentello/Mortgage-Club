var React = require('react/addons');

import { CommentBox } from './CommentBox';

var $ = require('jquery');

var render = () => {
  if ($("#content").length > 0) {
    React.render(
      <div>
        <CommentBox url="comments.json" pollInterval={2000} />
      </div>,
      document.getElementById('content')
    );
  }
};

$(function() {
  render();
  // Next part is to make this work with turbo-links
  $(document).on("page:change", () => {
    render();
  });
});
