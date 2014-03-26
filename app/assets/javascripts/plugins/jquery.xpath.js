(function ($) {
  var xp = function (xpath, contextNode) {
    var iterator = document.evaluate(xpath, contextNode, null, XPathResult.ANY_TYPE, null),
        node     = iterator.iterateNext(),
        nodes    = [];

    while (node) {
      nodes.push(node);
      node = iterator.iterateNext();
    }

    return nodes;
  };

  $.xpath = function (xpath) {
    return $(xp(xpath, document));
  }

  $.fn.xpath = function (xpath) {
    var nodes = [];

    this.each(function () {
      nodes.push.apply(nodes, xp(xpath, this));
    });

    return this.pushStack(nodes, "xpath", xpath);
  }
})(jQuery);