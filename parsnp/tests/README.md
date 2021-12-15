##About testing

- The test dataset comes from https://github.com/WGS-standards-and-analysis
- The reference tree is pulled from https://tree.opentreeoflife.org/curator/study/view/ot_301/?tab=home
- Tests check if output from FastTree and (default) RAxML versions is consistent:
  - Alignment files should be identical and match a reference alignment file generated with version 1.5.6
  - Tree files should match tree files generated with version 1.5.6
- ParSNP seems to be deterministic when run on the same computer but not between computers, see [this GitHub issue](https://github.com/marbl/parsnp/issues/99)
- Instead, we check the [normalized Robinson-Foulds distance](https://rdrr.io/cran/phangorn/man/treedist.html#:~:text=The%20normalized%20Robinson%2DFoulds%20distance,this%20value%20is%202n%2D6.) between outputted trees and the reference tree mentioned above
  - Basically, a RF distance of 0.28 means 28% of the total splits between the two trees are not shared 
  - I use a heuristic threshold of 0.5 to throw a red flag if any of the trees are _completely_ different