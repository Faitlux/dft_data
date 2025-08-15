#!/bin/bash



#结构优化
#./str.sh


rm -r 1_scf 2_band

#############
# 1scf 自洽 #
#############
mkdir 1_scf
cp POSCAR 1_scf/
cd 1_scf
#生成INCAR
vaspkit<<eof
101
ST
eof
#生成POTCAR和KPOINTS
vaspkit<<eof
102
2
0.02
eof

mpirun -n 2 vasp_std

#生成dos
vaspkit<<eof

eof

cd ../


#############
# 2计算能带 #
#############
mkdir 2_band
#复制自洽本征值波函数
cd 1_scf
cp INCAR POSCAR WAVECAR CHGCAR CHG ../2_band/
cd ../2_band
#生成能带k路径
vaspkit<<eof
303
eof
#3块体材料使用303
#二维材料使用302
mv KPATH.in KPOINTS

#取消第四行注释
sed -i '4s/# //' INCAR
#能带计算模式

mpirun -n 2 vasp_std

vaspkit<<eof
211
eof


