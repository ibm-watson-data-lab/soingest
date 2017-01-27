# soingest

A Stack Overflow data ingest tool written for OpenWhisk.

It consists of the following OpenWhisk actions:

- collector - polls the Stack Overflow API to pull question data, writing the data to IBM Message Hub
- store - for each changed question either creates or updates the data in a Cloudant database
- notify - turns a question object into Slack message

```
  TIMER --> collector --> MESSAGEHUB
  TIMER --> collector --> MESSAGEHUB
  MESSAGEHUB ---> store --> notify --> SLACK
```  