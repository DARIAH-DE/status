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

## Development

To test the functionally locally, do

```
bundle install
```

and

```
bundle exec jekyll serve
```

