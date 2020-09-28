const Chart = require("chart.js");
var ctx = document.getElementById("lineChart").getContext("2d");

var myChart = new Chart(ctx, {
  type: "line",
  data: {
    labels: temp_chart_labels,
    datasets: [
      {
        label: "Total # of Inquiries",
        backgroundColor: "rgba(155, 89, 182,0.2)",
        borderColor: "rgba(142, 68, 173,1.0)",
        pointBackgroundColor: "rgba(142, 68, 173,1.0)",
        data: temp_chart_data,
      },
    ],
  },
  options: {
    scales: {
      yAxes: [
        {
          ticks: {
            beginAtZero: true,
          },
        },
      ],
    },
  },
});
