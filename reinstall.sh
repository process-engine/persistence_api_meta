# remove "node_modules"
echo "Purging node_modules..."
find . -name "node_modules" -exec rm -rf '{}' +
echo "Done. Starting setup..."

# install all necessary dependencies
meta exec "npm run reinstall" --exclude runtime_layer_meta

# If npm install (or minstall) fails, stop any further execution.
# This is advisable since a failed npm install may lead to failures in the
# building process.
if [[ "$?" -ne "0" ]]; then
  printf "\e[1;31mError while executing npm install!\e[0m\n";
  exit 1;
fi

# Running this script through "npm install" will leave a package-lock file.
rm package-lock.json

echo "done"
