import os
import shutil

if os.path.exists("terraform.tfstate"):
  os.remove("terraform.tfstate")
if os.path.exists(".terraform.lock.hcl"):
  os.remove(".terraform.lock.hcl")
if os.path.exists("terraform.tfstate.backup"):
  os.remove("terraform.tfstate.backup")
if os.path.exists(".terraform"):
  shutil.rmtree (".terraform")
else:
  print("clean-up complete")
