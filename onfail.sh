set -x
mkdir -p /build
diag mkds --space codeship --name "${CI_REPO_NAME:-missing_repo_name} -- ${CI_BUILD_ID:-missing_build_id}" --desc "${CI_COMMIT_MESSAGE:-missing_commit_message}" -j > /build/dataset.json
cat /build/dataset.json | jq -r '. | "d/\(.id.space_id)/\(.id.item_id)"' > /build/dataset_id
diag cp /build/logs --name logs.zip $(cat /build/dataset_id)
diag cp /src --name source.zip --gitignore $(cat /build/dataset_id)
mkdir /build/log_annotate
diag cp $(cat /build/dataset_id) /build/log_annotate
diag annotate --dataset $(cat /build/dataset_id) "npm ERR" /build/log_annotate/logs.zip
