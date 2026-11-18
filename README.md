# meta-measy-linux

`meta-measy-linux` is the MEasyLinux functional layer collection. It keeps
product capabilities separate from SoC-vendor BSP layers so that a platform
upgrade does not mix board support, product policy, update policy, and reusable
engineering knowledge in one layer.

The repository layout follows the multi-layer model used by `meta-imx`: the
repository root is a container and each `meta-measy-*` child with a
`conf/layer.conf` is an independently selectable Yocto layer.

## Layers

| Layer | Responsibility | Current state |
| --- | --- | --- |
| `meta-measy-ai` | Versioned BSP, system, and Yocto agent skills; no target packages | Layer and initial skills available |
| `meta-measy-support` | AMP/OpenAMP/RPMsg, real-time Linux, and kernel crash capture | Layer skeleton; recipes remain to be implemented |
| `meta-measy-ota` | Product update policy and RAUC/SWUpdate backend integration | Layer skeleton; legacy backend trees remain migration inputs |
| `meta-measy-security` | Secure boot, signing, dm-verity, encryption, and related image integration | Existing implementation; Wrynose compatibility still requires validation |

The active source tree is based on Yocto Project Wrynose. New layers declare
only `wrynose` compatibility. Compatibility must be extended only after the
layer has parsed and its representative images have passed on that release.

## Dependency Direction

```text
openembedded-core / vendor BSP / optional upstream feature layers
                           |
                           v
        meta-measy-security | support | ota

meta-measy-ai (host-side knowledge; independent of image composition)
```

- Vendor BSP layers own bootloader, kernel, device trees, firmware, and board
  machine configuration.
- MEasy layers own reusable product capabilities and their integration policy.
- Product image and distro layers select the required MEasy layers and
  features; feature layers must not silently force a backend globally.
- Signing keys, production credentials, and irreversible provisioning actions
  must remain outside this repository.

Local documentation, when available, is kept under `docs/`:

- `LAYER_ARCHITECTURE.md` covers the directory model, dependency policy,
  feature selection, and migration plan.
- `measy-linux-layer-guide.html` is the Chinese layer guide, with diagrams,
  status definitions, layer responsibilities, and the AI/QA workflow.
- `YOCTO_CVE_REPORTING.md` covers Yocto CVE reporting, `sbom-cve-check`, VEX,
  and Timesys Vigiles using NXP UG10164 as a reference.

## Add Layers to a Build

Add only the functional layers needed by the product:

```bash
bitbake-layers add-layer ../sources/meta-measy-linux/meta-measy-ai
bitbake-layers add-layer ../sources/meta-measy-linux/meta-measy-support
bitbake-layers add-layer ../sources/meta-measy-linux/meta-measy-ota
bitbake-layers add-layer ../sources/meta-measy-linux/meta-measy-security
```

Then verify metadata visibility:

```bash
bitbake-layers show-layers
bitbake-layers show-appends
bitbake-layers show-overlayed
```

An empty functional layer is intentionally parseable while its recipes are
being developed. Its README must distinguish implemented behavior from planned
behavior.

## Known Migration Gaps

- The OTA backend directories are nested Git repositories and currently declare
  different release/platform assumptions. They must be audited and migrated,
  not published as the final root OTA layer unchanged.
- `meta-measy-security` does not yet declare Wrynose compatibility.
- `meta-measy-security/files/keys/` contains key-like development artifacts.
  Audit their provenance and licensing before publishing this collection, and
  move every production private key to controlled external infrastructure.
- AI, Support, and OTA are parseable skeletons and emit BitBake's expected
  no-recipe warning until their first real recipes are added.

## Licensing

New repository-authored metadata and documentation are provided under the MIT
license in `COPYING.MIT`, unless a file states otherwise. Imported or vendor
content retains its own license. A subtree must not be assumed to be MIT merely
because it is stored in this repository.

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) before adding recipes, appends, feature
flags, or skills. Every functional change must include parse evidence and a
platform-appropriate runtime or artifact check.
