package net.drfeel.ssm.controller;

import java.util.List;

import net.drfeel.ssm.entity.Department;
import net.drfeel.ssm.entity.Msg;
import net.drfeel.ssm.service.DepartmentService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 处理和部门有关的请求
 */
@RequestMapping("dept")
@Controller
public class DepartmentController {

	@Autowired
	private DepartmentService departmentService;

	/**
	 * 返回所有的部门信息
	 */
	@RequestMapping("/getAll")
	@ResponseBody
	public Msg getDepts(){
		// 查出的所有部门信息
		List<Department> list = departmentService.getDepts();
		System.out.println(list);
		return Msg.success().add("depts", list);
	}

	@RequestMapping(value="/delete/{id}", method = RequestMethod.PUT)
	public void test(@PathVariable("id") int id, Model model) {
		model.addAttribute("id", id);
		System.out.println(id);
	}

}
