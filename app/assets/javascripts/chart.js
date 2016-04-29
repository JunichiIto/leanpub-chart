$(function() {
  var purchaseCount = $('#placeholder').data().purchaseCount;

  var cumRoyalties = $('#placeholder').data().cumRoyalties;

  var goalData = $('#placeholder').data().goalData;

  function yenFormatter(v, axis) {
    return '$' + v.toFixed(axis.tickDecimals);
  }

  function toDate(sec) {
    var d = new Date();
    d.setTime(sec);
    return d;
  }

  function dateFormat(date) {
    var y = date.getFullYear();
    var m = date.getMonth() + 1;
    var d = date.getDate();

    if (m < 10) {
      m = '0' + m;
    }
    if (d < 10) {
      d = '0' + d;
    }

    return y + '/' + m + '/' + d;
  }

  var data = [{
    label: '購入数',
    data: purchaseCount,
    bars: {show: true},
    yaxis: 2
  }, {
    label: '累計額',
    data: cumRoyalties,
    lines: {show: true},
    points: {show: true}
  }, {
    label: '目標額',
    data: goalData,
    lines: {show: true}
  }];

  var options = {
    xaxes: [ { mode: 'time' } ],
    yaxes: [ {
      alignTicksWithAxis: 1,
      position: 'right',
      tickFormatter: yenFormatter
    }, { min: 0 } ],
    legend: { position: "ne" },
    colors: ["#eb941f", "#0088ce", "#c60c30"],
    grid: {
      hoverable: true
    },
  };

  $.plot("#placeholder", data, options);

  $("<div id='tooltip'></div>").css({
    position: "absolute",
    display: "none",
    border: "1px solid #fdd",
    padding: "2px",
    "background-color": "#fee",
    opacity: 0.80
  }).appendTo("body");

  $("#placeholder").bind("plothover", function (event, pos, item) {
    if (item) {
      var x = item.datapoint[0].toFixed(2),
        y = item.datapoint[1].toFixed(2);

      var text = dateFormat(toDate(x)) + " : $" + y
      $("#tooltip").html(text)
        .css({top: item.pageY+5, left: item.pageX+5})
        .fadeIn(200);
    } else {
      $("#tooltip").hide();
    }
  });
});
