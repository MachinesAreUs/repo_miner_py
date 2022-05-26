from pydriller import Repository
from erlport.erlterms import Atom
import sys

def integration_check():
    return Atom(b"ok")

def analyze(repo_url, auth_token):
    try:
        repo = Repository(repo_url.decode())
        return _analyze(repo)
    except:
        return (Atom(b"error"), "Could not analyze repository".encode())

def _analyze(repo):
    num_commits = _count_commits(repo)
    user_commits_histogram = _histogram_by_user(repo)
    monthly_commits_histogram = _histogram_by_month(repo)
    return (Atom(b"ok"),
            {
                Atom(b"num_commits"): num_commits,
                Atom(b"user_commits_histogram"): user_commits_histogram,
                Atom(b"monthly_commits_histogram"): monthly_commits_histogram
            })

def _count_commits(repo):
    count = 0
    for commit in repo.traverse_commits():
        count = count + 1
    return count

def _histogram_by_user(repo):
    histogram = {}
    for commit in repo.traverse_commits():
        author_name = commit.author.name.encode()
        if author_name in histogram:
            histogram[author_name] = histogram[author_name] + 1
        else:
            histogram[author_name] = 1
    return histogram

def _histogram_by_month(repo):
    histogram = {}
    for commit in repo.traverse_commits():
        year = commit.committer_date.year
        month = commit.committer_date.month
        if (year, month) in histogram:
            histogram[(year, month)] = histogram[(year, month)] + 1
        else:
            histogram[(year, month)] = 1
    return histogram
