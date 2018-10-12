package net.drfeel.ssm.entity;

public class Department {

    private Integer deptno;

    private String dname;

    public Department() {
    }

    public Department(Integer deptno, String dname) {

        this.deptno = deptno;
        this.dname = dname;
    }

    public Integer getDeptno() {
        return deptno;
    }

    public void setDeptno(Integer deptno) {
        this.deptno = deptno;
    }

    public String getDname() {
        return dname;
    }

    public void setDname(String dname) {
        this.dname = dname == null ? null : dname.trim();
    }

    @Override
    public String toString() {
        return "Department{" +
                "deptno=" + deptno +
                ", dname='" + dname + '\'' +
                '}';
    }
}