# Documentation

The DARIAH-DE status page is generated by [Jekyll](https://jekyllrb.com/).

It is automatically build on commit and deployed if successfully build. In case of a build error the committer is getting an e-mail note. Then please build the stuff locally and test there, please see [README](README.md).

## The infrastructure and its components

The DARIAH-DE infrastructure is modelled using [Jekyll Collections](https://jekyllrb.com/docs/collections/).
The model describes the infrastructure catalogue using four layers:

1. Services (Services users are depending on only)
2. Middlewares (Services/middlewares users AND other services/middlewares are depending on)
3. Servers (Hosts only)
4. Infrastructure (Infrastructure hosts are depending on)

Any item is described by a collection entry with the following metadata preamble.

```yaml
---
title: 'Item Title for display'
description: 'This is a sample entry'
website: 'http://item.url/'
teresah_included: true
dependencies:
  - '/infrastructure/otheritem'
  - '/servers/machine'
---
```

The `title` is required for all entries and used in status messages, for servers this should be the `fqdn`.
Please make sure to use a single title only once per layer.

The fields `description` and `website` are used for the entries in the list harvested by teresah.
The key `teresah_included` defaults to `true` for services, unless explicitly set to `false`.

The `dependencies` must be stated using the `id` of the collection entry,
i.e. `/:collection/:name` where `:collection` is the name of the collection and `:name` if the filename without extension of the entry.
If a dependency is listed that does not exist, the following error occurs:
```
Liquid Exception: Liquid error (line 6): divided by 0 in fulllist.md
```

Then please refer to chapter `Debugging YAML dependencies` below!


Dependency cycles, i.e. circular dependencies, are not allowed[^1].
Cycles in the dependencies will result in the following error:

```
Liquid Exception: Liquid error (line xx): Nesting too deep in fulllist.md
```

[^1]: Limiting recursion depth doesn't help, as than by the current design all services connected to the cycle would be affected by any outage.

The full list of all resolved dependencies can be found [here]({{ site.baseurl }}{% link fulllist.md %}).

## Outages and Announcements

All service disruptions and announcements are registered in [Jekyll Data Files](https://jekyllrb.com/docs/datafiles/)
in`_data/outages.yaml` and `_data/announcements.yaml` respectively.

```yaml
---
- title: 'This is the heading on the status page'
  description: 'This describes what the entry is about.'
  hide: false
  date_start: '2017-10-01 11:01'
  date_end: '2017-10-02 14:38'
  affected:
    - '/infrastructure/otheritem'
    - '/servers/machine'
  affected_services:
    - 'DARIAH Website'
```

Using [Liquid](https://shopify.github.io/liquid/) processing,
all services depending on any (or listed as) item in the `affected` array are shown on the status page.
The items of the `affected` array use the same `id` schema as the infrastructure components dependencies.
In case a non-existing item is listed, the same division by zero will be caused.
The `date_start` is required.

Explicit listing using the `affected_services` is discouraged in favour of dynamic catalogue resolution
and it will be ignored if the `affected` array is present.

The field `hide` defaults to `false` if absent, but can be used to hide messages from the status page.
Outages with a set `date_end` will also not be shown on the status page.

## History

For documentation purposes, previous outages and announcements should be added to the history `_data/history.yaml`,
which is displayed in the [History]({{ site.baseurl }}{% link history.md %}).

Since the catalogue may change, the history can not be generated by dynamically resolving dependencies.
Affected services must therefore be specified using the `affected_services` array.
To facilitate maintenance of the history, resolved outages and announcements (even if hidden)
are listed on the [current data]({{ site.baseurl }}{% link currentdata.md %}) page.

## Overview
{% include network.html %}

## TERESAH

The DARIAH-DE Status Jekyll page also includes the page with all DARIAH-DE services to be harvested by [TERESAH](http://teresah.dariah.eu/).
This includes all services except those explicitly excluded and all middlewares that are explicitly included, as long they have a `title`, `description` and `website` element.

## Debugging YAML dependencies

In case you get `divided by 0` errors, please debug missing YAML file dependencies by using the `yaml-test.sh` script. Please note, that on macs you may have to use `gsed` (and install via brew or macports before) instead of `sed`!

The test will check missing files and missing leading slashes and show ERRORS and WARNINGS. The history.yaml file will only WARN in case of breaking dependencies, it is excluded from the internal code checks due minor relevance for the internal dependency status computations.

---
