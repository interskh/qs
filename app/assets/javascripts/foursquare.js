var chart00, chart01, chart10, chart11;
$(document).ready(function() {
  drawFirstLevel();
  $('#back a').click(function(){
    chart10.destroy();
    chart11.destroy();
    drawFirstLevel();                
  });
});

function drawFirstLevel() {
  chart00 = new Highcharts.Chart( {
    chart: {
      renderTo: "foursquare_pie",
      plotBackgroundColor: null,
      plotBorderWidth: null,
      plotShadow: true
    },
    title: {
      text: "Checkins by Category"
    },
    plotOptions: {
      pie: {
        allowPointSelect: true,
        cursor: 'pointer',
        dataLabels: {
            enabled: true,
            color: '#000000',
            connectorColor: '#000000',
            formatter: function() {
                return '<b>'+ this.point.name +'</b>'+ this.percentage.toFixed(1) +' %';
            }
        },
        point: {
          events: {
            click: function() {
              drawSecondLevel(this.name);
            }
          }
        }
      }
    },
    series: [{
      type: 'pie',
      name: 'Checkins',
      data: data['category_all']
    }]
  });

  chart01 = new Highcharts.Chart( {
    chart: {
      renderTo: "foursquare_weekly_trend",
      type: "column",
    },
    title: {
      text: "Checkins by Week"
    },
    plotOptions: {
      column: {
        pointPadding: 0.2,
        borderWidth: 0
      }
    },
    xAxis: {
      type: "datetime"
    },
    yAxis: {
      title: "Checkins"
    },
    series: [{
      name: "Total",
      data: data['all_by_week']
    }]
  });

  var i = 0;
  var top_cats = new Object();
  for (var k in data["category_all"]) {
    top_cats[i] = data["category_all"][k][0];
    if (i==3) {
      break;
    }
    i++;
  }
  chart01 = new Highcharts.Chart( {
    chart: {
      renderTo: "foursquare_monthly_trend",
      type: "column",
    },
    title: {
      text: "Checkins by Month"
    },
    plotOptions: {
      column: {
        pointPadding: 0.2,
        borderWidth: 0
      }
    },
    xAxis: {
      type: "datetime"
    },
    yAxis: {
      title: "Checkins"
    },
    series: [{
      name: "Total",
      data: data['all_by_month']
    },
    {
      name: top_cats[0],
      data: data['category_by_month'][top_cats[0]]
    },
    {
      name: top_cats[1],
      data: data['category_by_month'][top_cats[1]]
    },
    {
      name: top_cats[2],
      data: data['category_by_month'][top_cats[2]]
    },
    {
      name: top_cats[3],
      data: data['category_by_month'][top_cats[3]]
    }]
  });
}

function drawSecondLevel(name) {
  chart00.destroy();
  chart01.destroy();
  chart02.destroy();
  chart10 = new Highcharts.Chart( {
    chart: {
      renderTo: "foursquare_pie",
      plotBackgroundColor: null,
      plotBorderWidth: null,
      plotShadow: true
    },
    title: {
      text: "Checkins by Category " + name
    },
    plotOptions: {
      pie: {
        allowPointSelect: true,
        cursor: 'pointer',
        dataLabels: {
            enabled: true,
            color: '#000000',
            connectorColor: '#000000',
            formatter: function() {
                return '<b>'+ this.point.name +'</b>'+ this.percentage.toFixed(1) +' %';
            }
        }
      }
    },
    series: [{
      type: 'pie',
      name: 'Checkins',
      data: data['category_detailed'][name]
    }]
  });

  chart11 = new Highcharts.Chart( {
    chart: {
      renderTo: "foursquare_trend",
      type: "column",
    },
    title: {
      text: "Checkins by Week"
    },
    plotOptions: {
      column: {
        pointPadding: 0.2,
        borderWidth: 0
      }
    },
    xAxis: {
      type: "datetime"
    },
    yAxis: {
      title: "Checkins"
    },
    series: [{
      name: "Checkins",
      data: data['category_by_week'][name]
    }]
  });
}
