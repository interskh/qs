var chart0, chart1, chart2;
$(document).ready(function() {
  drawFirstLevel();

  $('#back a').click(function(){
    chart0.destroy();
    chart1.destroy();
    drawFirstLevel();                
  });

  $('#timeframe-nav a').click(function(){
//    $('#timeframe-nav li.active').removeClass('active');
//    $(this).parent().addClass('active');
  });
});

function drawFirstLevel() {
  $('#back a').addClass('disabled');
  chart0 = new Highcharts.Chart( {
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
                return '<b>'+ this.point.name +'</b>'+ this.point.y; //percentage.toFixed(1) +' %';
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

  chart0 = new Highcharts.Chart( {
    chart: {
      renderTo: "foursquare_pie_all_category",
      plotBackgroundColor: null,
      plotBorderWidth: null,
      plotShadow: true
    },
    title: {
      text: "Checkins by All Category"
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
                return '<b>'+ this.point.name +'</b>'+ this.point.y; //this.percentage.toFixed(1) +' %';
            }
        }
      }
    },
    series: [{
      type: 'pie',
      name: 'Checkins',
      data: data['category_all_detailed']
    }]
  });

  chart1 = new Highcharts.Chart( {
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
  chart2 = new Highcharts.Chart( {
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
  $('#back a').removeClass('disabled');
  chart0.destroy();
  chart1.destroy();
  chart2.destroy();
  chart0 = new Highcharts.Chart( {
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

  chart1 = new Highcharts.Chart( {
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
      name: "Checkins",
      data: data['category_by_week'][name]
    }]
  });
}
