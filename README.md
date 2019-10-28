# Profiling JDBC
I tend to use few tools whenever i find myself needing to profile JDBC and monitoring what queries my apps are making.

## OpenTracing JDBC Tracer and Jaeger
If you happen to be using [opentracing](http://opentracing.io) to trace your application, [java-jdbc](https://github.com/opentracing-contrib/java-jdbc) is a great tool to add to your aresenal (only tested in dev env) to give you visibility on what queries get executed in each tace.

I wrote this script to help me measure how many queries are getting executed per table.

It works like this:
- Integrate `java-jdbc` into your app
- Run [Jaeger](http://jaegertracing.io) and start sending your traces there
- Once you find a Trace that you are interested in fetching all child queries, run `scripts/jaeger-jdbc-traces.sh <trace-id>`. (TraceId can be found in Jaeger UI)
- The script will download the trace and child spans from Jaeger and spit out three files
  - `scripts/data/spans-$TRACE_ID.json` contains the trace json and returned from Jaeger
  - `script/data/queries-$TRACE_ID.txt` all the queries contained in the Trace as reported by `java-jdbc` tracer.
  - `script/data/tables-$TRACE_ID.txt` count of queries per table.
