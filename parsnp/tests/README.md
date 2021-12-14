##About testing

- The test dataset comes from https://github.com/WGS-standards-and-analysis
- The reference tree is pulled from https://tree.opentreeoflife.org/curator/study/view/ot_301/?tab=home
- Tests check if output from FastTree and (default) RAxML versions is consistent:
  - Alignment files should be identical and match a reference alignment file generated with version 1.5.6
  - Tree files should match tree files generated with version 1.5.6