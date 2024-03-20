import {
  Card,
  CardBody,
  CardHeader,
  Typography,
} from "@material-tailwind/react";
import Chart from "react-apexcharts";
 
const chartConfig1 = {
  type: "bar",
  height: 240,
  series: [
    {
      name: "Strength",
      data: [540, 300, 320, 500, 350, 200, 230, 500,215],
    },
  ],
  options: {
    chart: {
      toolbar: {
        show: false,
      },
    },
    title: {
      display: true,
      text: 'Student Strength Distribution in Mess'
    },
    dataLabels: {
      enabled: false,
    },
    colors: ["#020617"],
    plotOptions: {
      bar: {
        columnWidth: "40%",
        borderRadius: 2,
      },
    },
    xaxis: {
      axisTicks: {
        show: false,
      },
      axisBorder: {
        show: false,
      },
      labels: {
        style: {
          colors: "#616161",
          fontSize: "12px",
          fontFamily: "inherit",
          fontWeight: 400,
        },
      },
      categories: [
        "Alder",
        "Pine",
        "Oak",
        "Tulsi",
        "Peepal",
        "D3",
        "D2",
        "D1",
        "Yoga",
      ],
    },
    yaxis: {
      labels: {
        style: {
          colors: "#616161",
          fontSize: "12px",
          fontFamily: "inherit",
          fontWeight: 400,
        },
      },
    },
    grid: {
      show: false,
      borderColor: "#dddddd",
      strokeDashArray: 5,
      xaxis: {
        lines: {
          show: true,
        },
      },
      padding: {
        top: 5,
        right: 20,
      },
    },
    fill: {
      opacity: 0.8,
    },
    tooltip: {
      theme: "dark",
    },
  },
};
 
export default function HomeCard1() {
  return (
    <Card>
      <CardBody className="px-2 pb-0">
        <Chart {...chartConfig1} />
      </CardBody>
    </Card>
  );
}