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
                    20.4167,
                    23.4167,
                    26,
                    30.25,
                    42.5,
                    43.8333,
                    59.6667,
                    50.5
                ],
                "borderRadius": 0
            },
            {
                "label": "ALB",
                "data": [
                    2.8,
                    3.1667,
                    4.4167,
                    3.1667,
                    7.3333,
                    8.5,
                    12.8333,
                    8
                ],
                "borderRadius": 0
            },
            {
                "label": "HSV",
                "data": [
                    9.25,
                    9.0833,
                    10.5,
                    12.4167,
                    15.9167,
                    14.5,
                    12.1667,
                    14.25
                ],
                "borderRadius": 0
            },
            {
                "label": "LUP",
                "data": [
                    3.3333,
                    4.3333,
                    5.5833,
                    7.5,
                    9.8333,
                    7.75,
                    11.4167,
                    10.5
                ],
                "borderRadius": 0
            },
            {
                "label": "HHS",
                "data": [
                    5.3333,
                    6.5,
                    5.8333,
                    7.1667,
                    9.5833,
                    12.75,
                    23,
                    17
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
