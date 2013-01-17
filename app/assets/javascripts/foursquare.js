var chart00, chart01, chart10, chart11;
$(document).ready(function() {
  drawFirstLevel();
  $('#back a').click(function(){
    chart10.destroy();
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
      name: 'Browser share',
      data: data['all']
    }]
  });
}

function drawSecondLevel(name) {
  chart00.destroy();
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
      name: 'Browser share',
      data: data['detailed'][name]
    }]
  });
}
