---
headless: true
---
<h1>Publikasjonar om berekraftsmål</h1>
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
                    21.3333,
                    24.5,
                    29.1667,
                    31.8333,
                    45.0833,
                    47,
                    65,
                    50.3333
                ],
                "borderRadius": 0
            },
            {
                "label": "ALB",
                "data": [
                    3,
                    4.0833,
                    6.1667,
                    5.1667,
                    9.25,
                    10.9167,
                    16.5,
                    7
                ],
                "borderRadius": 0
            },
            {
                "label": "HSV",
                "data": [
                    9.25,
                    8.25,
                    11,
                    11.4167,
                    15.5,
                    13,
                    12.0833,
                    13.3333
                ],
                "borderRadius": 0
            },
            {
                "label": "LUP",
                "data": [
                    3.4167,
                    5.1667,
                    5.8333,
                    7.75,
                    10.1667,
                    8.5,
                    11.8333,
                    13.6667
                ],
                "borderRadius": 0
            },
            {
                "label": "HHS",
                "data": [
                    6.0833,
                    6.5833,
                    6.75,
                    6.9167,
                    9.8333,
                    14.1667,
                    23.8333,
                    15.3333
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
                    "text": "År"
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
                    "text": "Gjennomsnittstal på publikasjonar per månad"
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
