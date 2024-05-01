---
headless: true
---
<h1>Publications on Sustainable Development Goals</h1>
{{< chart >}}{
    "type": "line",
    "data": {
        "labels": [
            "2017",
            "2018",
            "2019",
            "2020",
            "2021",
            "2022",
            "2023",
            "2024"
        ],
        "datasets": [
            {
                "label": "INN",
                "data": [
                    21.75,
                    23.5833,
                    28.8333,
                    32.8333,
                    44.75,
                    47,
                    61.5833,
                    50.25
                ],
                "borderRadius": 0
            },
            {
                "label": "ALB",
                "data": [
                    3,
                    3.5,
                    5.8333,
                    5,
                    8.8333,
                    11.1667,
                    14.5833,
                    9.5
                ],
                "borderRadius": 0
            },
            {
                "label": "HSV",
                "data": [
                    10,
                    8.5833,
                    10.6667,
                    12.25,
                    15.8333,
                    13.4167,
                    12.6667,
                    12.5
                ],
                "borderRadius": 0
            },
            {
                "label": "LUP",
                "data": [
                    3.1667,
                    4.6667,
                    6,
                    7.5,
                    9.75,
                    8.4167,
                    11.75,
                    12
                ],
                "borderRadius": 0
            },
            {
                "label": "HHS",
                "data": [
                    6.0833,
                    6.8333,
                    6.75,
                    8,
                    9.9167,
                    13.6667,
                    22.1667,
                    16
                ],
                "borderRadius": 0
            }
        ]
    },
    "options": {
        "elements": {
            "line": {
                "borderWidth": 2
            }
        },
        "animation": {
            "duration": 500,
            "easing": "linear"
        },
        "maintainAspectRatio": false,
        "responsive": true,
        "scales": {
            "x": {
                "display": true,
                "title": {
                    "display": true,
                    "text": "year"
                },
                "stacked": false,
                "grid": {
                    "display": false
                }
            },
            "y": {
                "display": true,
                "title": {
                    "display": true,
                    "text": "Average number of publications per month"
                },
                "stacked": false,
                "grid": {
                    "display": false
                },
                "beginAtZero": true
            }
        },
        "plugins": {
            "legend": {
                "display": true,
                "position": "bottom"
            }
        }
    }
}
{{< /chart >}}
