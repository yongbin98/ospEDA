# ospEDA

ospEDA is a MATLAB implementation of the *Orthogonal Subspace Projection-based Electrodermal Activity decomposition algorithm*.  

This method separates tonic and phasic components of the EDA signal.

For research-related inquiries, please contact Yongbin Lee (yongbin.lee@uconn.edu).

# Quick Start
To visualize example simulated EDA signals, run: `plot_examples.m`

To evaluate performance metrics on simulated EDA data, run: `evaluation_algorithms.m`

To generate simulated EDA data, run: `generate_simulated_EDA.m`

# Other EDA Decomposition Methods
Ledalab-CDA and DDA: http://www.ledalab.de/

sparsEDA: https://github.com/fhernandogallego/sparsEDA

cvxEDA: https://github.com/lciti/cvxEDA

BayesianEDA: https://github.com/computational-medicine-lab/BayesianEDA-For-Sharing

UDM: https://github.com/huisophiewang/UDM_EDA

## Citation

If this repository is helpful for your research, please cite:

Lee, Y., Kong, Y., & Chon, K. H. (2026). ospEDA: Orthogonal Subspace Projection for Electrodermal Activity Decomposition. *IEEE Transactions on Biomedical Engineering*, Early Access. https://doi.org/10.1109/TBME.2026.3703619

BibTeX:

```bibtex
@article{lee2026ospeda,
  title={ospEDA: Orthogonal Subspace Projection for Electrodermal Activity Decomposition},
  author={Lee, Yongbin and Kong, Youngsun and Chon, Ki H.},
  journal={IEEE Transactions on Biomedical Engineering},
  year={2026},
  pages={1--13},
  doi={10.1109/TBME.2026.3703619},
  note={Early Access}
}
```
