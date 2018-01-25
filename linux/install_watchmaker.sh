GIT_REPO="${tfi_repo}"
GIT_BRANCH="${tfi_branch}"

PIP_URL=https://bootstrap.pypa.io/get-pip.py
PYPI_URL=https://pypi.org/simple

# Install pip
curl "$PIP_URL" | python - --index-url="$PYPI_URL" wheel==0.29.0

# Install git
yum -y install git

# Upgrade pip and setuptools
pip install --index-url="$PYPI_URL" --upgrade pip setuptools boto3

# Clone watchmaker
git clone "$GIT_REPO" --branch "$GIT_BRANCH" --recursive

# Install watchmaker
cd watchmaker
pip install --index-url "$PYPI_URL" --editable .

# Run watchmaker
watchmaker ${tfi_common_args} ${tfi_lx_args}
