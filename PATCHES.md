# PATCHES.md — the permanent merge-tax ledger

Every edit to a vendored (pstack-origin) file is registered here. This list is the complete
merge-conflict forecast for every future `git merge vendor`, and the wire-check's input: each
entry carries a `grep:` pattern that must hit after any vendor merge, or the wire is dead even
though the merge was textually clean.

Discipline: additive files are never listed (they cannot conflict). An entry is added in the
same commit as its patch. The wire-check (`scripts/wire-check.sh`) greps every pattern and
fails loudly on a miss.

Refresh procedure:
```
cd <cursor-plugins clone> && git subtree split --prefix=pstack -b pstack-split
cd ~/Documents/pkstack && git fetch <clone> pstack-split:vendor-new
git checkout vendor && git merge --ff-only vendor-new && git checkout main
git merge vendor && scripts/wire-check.sh
```

## P0 — merge-time resolutions (not wires; recorded for the next merge)

| file | resolution |
|---|---|
| `.cursor-plugin/plugin.json` | ours (pkstack manifest) |
| `README.md` | ours (pkstack README) |
| `skills/create-verification-skill/**` | ours — kstack v0.3 superset; pstack's create/maintain interview already folded in |

## Wires (P1/P2 entries appended as they land)

<!-- entry format:
### <wire-id> — <file>
why: <one line>
grep: <pattern that must hit post-merge>
-->
