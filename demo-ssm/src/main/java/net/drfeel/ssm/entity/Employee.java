package net.drfeel.ssm.entity;

public class Employee {

    private Integer empno;

    private String ename;

    private String gender;

    private String email;

    private Integer deptno;

    private Department department;

    public Employee() {
    }

    public Employee(Integer empno, String ename, String gender, String email, Integer deptno) {
        this.empno = empno;
        this.ename = ename;
        this.gender = gender;
        this.email = email;
        this.deptno = deptno;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

    public Integer getEmpno() {
        return empno;
    }

    public void setEmpno(Integer empno) {
        this.empno = empno;
    }

    public String getEname() {
        return ename;
    }

    public void setEname(String ename) {
        this.ename = ename == null ? null : ename.trim();
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender == null ? null : gender.trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email == null ? null : email.trim();
    }

    public Integer getDeptno() {
        return deptno;
    }

    public void setDeptno(Integer deptno) {
        this.deptno = deptno;
    }

    @Override
    public String toString() {
        return "Employee{" +
                "empno=" + empno +
                ", ename='" + ename + '\'' +
                ", gender='" + gender + '\'' +
                ", email='" + email + '\'' +
                ", deptno=" + deptno +
                '}';
    }
}