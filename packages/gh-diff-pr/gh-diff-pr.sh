# Based on https://daisy.wtf/writing/github-changes-since-last-review

# Use the GitHub API to get the references we need
PR_NUMBER=$1

MY_USER_ID=$(gh api "/user" -q '.id')

PR_HEAD_SHA=$(gh api "/repos/{owner}/{repo}/pulls/$PR_NUMBER" -q '.head.sha')

PR_LAST_REVIEW_SHA=$(gh api "/repos/{owner}/{repo}/pulls/$PR_NUMBER/reviews" \
  -q "map(select(.user.id == $MY_USER_ID) | .commit_id)[-1]")

# Fetch the commits we want to compare, unless we already have
if \
  test $(git cat-file -t ${PR_LAST_REVIEW_SHA} || echo 'none') != commit \
  -o $(git cat-file -t ${PR_HEAD_SHA} || echo 'none') != commit
then
  git fetch origin ${PR_LAST_REVIEW_SHA} ${PR_HEAD_SHA}
fi

# Compare the ranges
git range-diff main ${PR_LAST_REVIEW_SHA} ${PR_HEAD_SHA}
