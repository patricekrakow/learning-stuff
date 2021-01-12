# Playing with Eleventy

## Reference

<https://www.11ty.dev/>

## Prerequisites

Eleventy v0.11.1 requires Node 8 or newer.

```text
$ node --version
v12.16.3
```

## Getting Started

Let's first install eleventy using `npm`:

```text
$ npm install -g @11ty/eleventy
...
+ @11ty/eleventy@0.11.1
added 393 packages from 395 contributors in 74.023s
...
```

Then, we create a simple sample page with an editor:

```text
$ touch README.md
```

```markdown
# This is a Title

This is a text.
```

And, we can _compile_ it with `eleventy`:

```text
$ eleventy
Writing _site/README/index.html from ./README.md.
Wrote 1 file in 0.39 seconds (v0.11.1)
```

Finally, we can see the result locally:

```text
$ eleventy --serve
Writing _site/README/index.html from ./README.md.
Wrote 1 file in 0.26 seconds (v0.11.1)
Watching…
[Browsersync] Access URLs:
 -------------------------------------
       Local: http://localhost:8080
    External: http://192.168.1.10:8080
 -------------------------------------
          UI: http://localhost:3001
 UI External: http://localhost:3001
 -------------------------------------
[Browsersync] Serving files from: _site
```

<http://localhost:8080/README/>
