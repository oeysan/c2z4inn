---
headless: true
encoding: UTF-8
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
            "2024",
            "2025"
        ],
        "datasets": [
            {
                "label": "INN",
                "data": [
                    41.75,
                    40.0833,
                    50.5,
                    49,
                    61.3333,
                    70.75,
                    93.75,
                    82.25,
                    60.3333
                ],
                "borderRadius": 0
            },
            {
                "label": "ALB",
                "data": [
                    4.3,
                    4.6667,
                    6.8333,
                    5.1667,
                    11,
                    12.6667,
                    16.9167,
                    11.8333,
                    11
                ],
                "borderRadius": 0
            },
            {
                "label": "LUP",
                "data": [
                    8,
                    13.0833,
                    15,
                    12.6667,
                    14.75,
                    16.6667,
                    23.8333,
                    20.5833,
                    13.6667
                ],
                "borderRadius": 0
            },
            {
                "label": "HSV",
                "data": [
                    12.9167,
                    10.8333,
                    16.9167,
                    17.4167,
                    21.0833,
                    20.1667,
                    17.5,
                    21.0833,
                    15.3333
                ],
                "borderRadius": 0
            },
            {
                "label": "HHS",
                "data": [
                    17.0833,
                    11.0833,
                    12.9167,
                    13.25,
                    14.6667,
                    20.6667,
                    34.4167,
                    26.75,
                    21.3333
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
