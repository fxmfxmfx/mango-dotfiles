# Signed browser packages

Install all three files once through LibreWolf/Firefox `about:addons` > gear >
**Install Add-on From File**. These are persistent installations; do not load
these packages through `about:debugging`.

| File | Role | Add-on ID |
| --- | --- | --- |
| `desktop-theme-bridge-1.0.0.xpi` | Mango Desktop Theme Bridge: activates the mapped installed theme | `desktop-theme@mango-dotfiles.local` |
| `gruvbox-dark-1.1.xpi` | Gruvbox Dark, for cflowers and gruvbox | `{eb8c4a94-e603-49ef-8e81-73d3c4cc04ff}` |
| `catppuccin-1.0.xpi` | Catppuccin, for catppuccin-mocha | `{f5525f34-4102-4f6e-8478-3cf23cfeff7a}` |

These original signed archives are copied unchanged. `SHA256SUMS` records their
exact bytes; `desktop-theme-browser-setup --check` checks those digests and ZIP
integrity/signature-file presence. The browser verifies the Mozilla signature
when installing. Editing or repackaging a signed archive invalidates it.

The bridge's matching source is in `../browser-extension/`. Its local handler
must also be registered with `~/.local/bin/desktop-theme-browser-setup` after
installing the dotfiles. Merely installing an XPI cannot register a native host.
No Mozilla developer account or signing service is needed to use these already
signed packages. A changed bridge build needs its own version and signature.

## Third-party themes and attribution

- **Gruvbox Dark 1.1**, by **calvinchd**:
  [original AMO listing](https://addons.mozilla.org/firefox/addon/gruvbox-dark-theme/),
  [Creative Commons Attribution 3.0](https://creativecommons.org/licenses/by/3.0/).
- **Catppuccin 1.0**, by **Labrat**:
  [original AMO listing](https://addons.mozilla.org/firefox/addon/catppuccin/),
  [Creative Commons Attribution-NonCommercial 3.0](https://creativecommons.org/licenses/by-nc/3.0/).

Author/license attribution above follows the corresponding AMO listings.
These third-party theme packages retain their upstream licensing; the dotfiles
repository's MIT license does not replace it. The installed Catppuccin browser
theme is this particular published preset, not the official Catppuccin project.
