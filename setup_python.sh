conda install -y pytorch torchvision torchaudio -c pytorch
conda install -y numpy scipy
cd ~/git_repos/
git clone https://github.com/tensorly/tensorly
cd tensorly
pip install -e .

git clone https://github.com/tensorly/torch
cd torch
pip install -e .

git clone https://github.com/tensorly/quantum
cd quantum
pip install -e .
