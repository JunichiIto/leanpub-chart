$(function() {
  var purchaseCount = $('#placeholder').data().purchaseCount;

  var goalData = $('#placeholder').data().goalData;

  var cumRoyalties = $('#placeholder').data().cumRoyalties;

  function yenFormatter(v, axis) {
    return '$' + v.toFixed(axis.tickDecimals);
  }

  $.plot("#placeholder", [{
    label: '購入数',
    data: purchaseCount,
    bars: { show: true },
    yaxis: 2
  }, {
    label: '目標額',
    data: goalData,
    lines: { show: true }
  }, {
    label: '累計額',
    data: cumRoyalties,
    lines: { show: true },
    points: { show: true }
  }, {
  }], {
    xaxes: [ { mode: 'time' } ],
    yaxes: [ {
      alignTicksWithAxis: 1,
      position: 'right',
      tickFormatter: yenFormatter
    }, { min: 0 } ],
    legend: { position: "ne" }
  });
});
