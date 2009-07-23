== 0.2.5 (in progress)
- Added YAJLGen wrapper for yajl_gen
- Added streaming support to YAJLDocument
- Added NSString category
- Added NSObject category

== 0.2.4

- Using yajl_number callback since its more compliant (correctly handles large double values)
- Changing YAJLParser API to allow for streaming data
- Added test for overflow.json
- Added test for insane sample.json

== 0.2.3

- Fixed memory leak in YAJLParser