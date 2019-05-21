# DARIAH-DE Status #

This is the DARIAH-DE Status page, served under [https://dariah-de.github.io/status/](https://dariah-de.github.io/status/).

The status page is powered by [Jekyll](https://jekyllrb.com/) using its features for [Collections](https://jekyllrb.com/docs/collections/) and [Data Files](https://jekyllrb.com/docs/datafiles/) to keep track of the infrastructure and its status.


## How it works

See the [documentation](documentation.md).

## Quickstart for setting outages

Just use the code block below to quickly set outages in ```/_data/outages.yaml```. Note that ```date_end``` must NOT be existing in the block (why is that?). Under ```affected:``` just put in pathes to affected infrastructure, servers, middleware, and services. Do put in the most basic affected (not depending on each other) terms only, such as ```- /servers/wiki```, or ```- /infrastructure/gwdg-cloud``` if the wiki server and the cloud infrastructure are down. All services depending on the affected ones will be listed automatically.

```
---
- title: 'DARIAH-DE Wiki and GWDG Cloud infrastructure not available'
  date_start: '2019-05-17'
  hide: false
  description: 'Due to some reason the DARIAH-DE Wiki and the GWDG Cloud infrastructure are not available at the moment. We apologize for the inconvenience! Please have a look at <a href="#">THIS PAGE</a> for more information!'
  affected:
    - '/servers/wiki'
    - '/infrastructure/gwdg-cloud'
```

If you want to, please test the outcome locally, as described below. For detailed information please see the [documentation](documentation.md).


## Development

To test the functionally locally, do

```
bundle install
```

and

```
bundle exec jekyll serve
```
test
