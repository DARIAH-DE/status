# DARIAH-DE Status #

This is the DARIAH-DE Status page, served under [https://dariah-de.github.io/status/](https://dariah-de.github.io/status/).

The status page is powered by [Jekyll](https://jekyllrb.com/) using its features for [Collections](https://jekyllrb.com/docs/collections/) and [Data Files](https://jekyllrb.com/docs/datafiles/) to keep track of the infrastructure and its status.


## How it works

See the [documentation](documentation.md).

Changes in the data must be reflected in the graph, so make sure to re-compile!
Make sure to have `graphviz` and the python dependencies from `requirements.txt`, e.g. on Ubuntu:
``` Bash
sudo apt-get -y install graphviz
sudo apt-get -y install python3-all-dev python3-pip
python3 -m venv myvenv
source myvenv/bin/activate
pip3 install -r requirements.txt
```

Than compile with `python3 render_graph.py`.


## Quickstart for setting outages

Just use the code block below to quickly set outages in ```/_data/outages.yaml```. Note that ```date_end```must NOT be existing in the block (why is that?)! Under ```affected:```just put in pathes to infrastructure, servers, middleware, and services. Do put in the most basic affected (and not depending on each other) terms only, such as ```- /servers/wiki```, or ```- /infrastructure/gwdg-cloud``` if the wiki server or the cloud infrastructure is down. All dependent services will be listed automatically.

```
---
- title: 'Something is NOT available'
  date_start: '2019-05-17'
  hide: false
  description: 'Due to arglblargl the Blubifugi service is not available at the moment. We apologize for the inconvenience!'
  affected:
    - '/services/tg_website'
    - '/services/tgrep'
```

If you want to, please test the outcome locally, as described below.


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
