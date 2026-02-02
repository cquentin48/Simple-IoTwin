import subprocess

sh_coverage_cmd = "lcov --summary cov_result.info | grep 'lines.......:' | awk '{print substr($2,1, length($2)-1)}'"
ps = subprocess.Popen(sh_coverage_cmd, shell=True, stdout=subprocess.PIPE, stderr = subprocess.STDOUT)
output = ps.communicate()[0]
coverage_percentage = float(str(output).replace("b'","").replace("\\n'",""))

print(f"Current coverage percentage : {coverage_percentage}%")

if coverage_percentage > 80.0:
    print(f"The coverage percentage must be at least at {80.0}%!")
    exit(1)
else:
    exit(0)