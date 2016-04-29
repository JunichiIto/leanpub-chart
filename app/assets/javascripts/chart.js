$(function() {
  var purchaseCount = $('#placeholder').data().purchaseCount;

  var cumRoyalties = $('#placeholder').data().cumRoyalties;

  var goalData = $('#placeholder').data().goalData;

  function yenFormatter(v, axis) {
    return '$' + v.toFixed(axis.tickDecimals);
  }

  function countFormatter(v, axis) {
    return v.toFixed(axis.tickDecimals) + $('#placeholder').data().purchaseUnit;
  }

  function dateFormatter(v, axis) {
    return dateFormat(toDate(v), true);
  }

  function toDate(sec) {
    var d = new Date();
    d.setTime(sec);
    return d;
  }

  function dateFormat(date, withoutYear) {
    var y = date.getFullYear();
    var m = date.getMonth() + 1;
    var d = date.getDate();

    if (m < 10) {
      m = '0' + m;
    }
    if (d < 10) {
      d = '0' + d;
    }

    if (withoutYear) {
      return  m + '/' + d;
    } else {
      return y + '/' + m + '/' + d;
    }
  }

  var data = [{
    label: $('#placeholder').data().purchaseCountLabel,
    data: purchaseCount,
    bars: {show: true, barWidth: 20000000, align: 'center'},
    yaxis: 2
  }, {
    label: $('#placeholder').data().cumRoyaltiesLabel,
    data: cumRoyalties,
    lines: {show: true, lineWidth: 5},
    points: {show: true}
  }, {
    label: $('#placeholder').data().royaltyGoalLabel,
    data: goalData,
    lines: {show: true}
  }];

  var options = {
    xaxes: [ { mode: 'time', tickFormatter: dateFormatter } ],
    yaxes: [ {
      alignTicksWithAxis: 1,
      position: 'right',
      tickFormatter: yenFormatter
    }, { min: 0, tickFormatter: countFormatter } ],
    legend: { position: "ne" },
    colors: ["#eb941f", "#55a868", "#c60c30"],
    grid: {
      hoverable: true
    }
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
      var x = item.datapoint[0].toFixed(0);

      var text = null;
      if (item.seriesIndex == 0) {
        var y = item.datapoint[1].toFixed(0);
        text = dateFormat(toDate(x)) + " : " + y + $('#placeholder').data().purchaseUnit;
      } else if (item.seriesIndex == 1) {
        var y = item.datapoint[1].toFixed(2);
        text = dateFormat(toDate(x)) + " : $" + y;
      } else if (item.seriesIndex == 2) {
        var y = item.datapoint[1].toFixed(2);
        text = "$" + y;
      }
      if (text) {
        $("#tooltip").html(text)
          .css({top: item.pageY+5, left: item.pageX+5})
          .fadeIn(200);
      }
    } else {
      $("#tooltip").hide();
    }
  });
});
