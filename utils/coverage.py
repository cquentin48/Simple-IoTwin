import subprocess

sh_coverage_cmd = "lcov --summary cov_result.info"
ps = subprocess.Popen(sh_coverage_cmd, shell=True, stdout=subprocess.PIPE, stderr = subprocess.STDOUT)
output = ps.communicate()[0]

if '\n' in lines:
    output = [detail.strip()
              for detail in output.split('\n')
              if detail.strip().startswith('lines')
              ][0]
    coverage_percentage = output.split(': ')[1].split(' ')[0]
    coverage_percentage = float(coverage_percentage.replace('%',''))
else:
    if output == b'':
        print("No percentage found!")
        exit(1)

    print(f"Current coverage percentage : {output}")

    coverage_percentage = float(str(output).replace("b'","").replace("\\n'",""))


if coverage_percentage > 80.0:
    print(f"The coverage percentage must be at least at {80.0}%!")
    exit(1)
else:
    exit(0)