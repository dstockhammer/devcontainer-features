
# Helmfile (helmfile)

Installs [Helmfile](https://github.com/helmfile/helmfile).

## Example Usage

```json
"features": {
    "ghcr.io/dstockhammer/devcontainer-features/helmfile:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| failOnError | Whether to fail the container build if the feature fails to install. | boolean | false |
| version | The version of Helmfile to install. | string | latest |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/dstockhammer/devcontainer-features/blob/main/src/helmfile/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
