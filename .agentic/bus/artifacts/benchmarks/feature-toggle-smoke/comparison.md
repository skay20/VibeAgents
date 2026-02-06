# A/B Metrics Comparison

- Baseline run: `ab-base-20260206`
- Experiment run: `ab-exp-20260206`
- Benchmark id: `feature-toggle-smoke`

## Summary
| Metric | Baseline | Experiment | Delta (Exp-Base) |
| --- | ---: | ---: | ---: |
| Total agents used | 1 | 1 | 0 |
| Blocked | 0 | 0 | 0 |
| Failed | 0 | 0 | 0 |
| Avg duration (ms) | 3000 | 4200 | 1200 |
| Tokens in | 120 | 180 | 60 |
| Tokens out | 240 | 360 | 120 |
| Questions asked | 0 | 0 | 0 |
| Answers received | 0 | 0 | 0 |

## Per-Agent Delta
| Agent | Base Status | Exp Status | Base Duration | Exp Duration | Delta Duration | Base Tokens In | Exp Tokens In | Delta Tokens In | Base Tokens Out | Exp Tokens Out | Delta Tokens Out |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| implementer | ok | ok | 3000 | 4200 | 1200 | 120 | 180 | 60 | 240 | 360 | 120 |
