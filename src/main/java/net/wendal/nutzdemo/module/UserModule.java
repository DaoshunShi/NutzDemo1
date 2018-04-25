package net.wendal.nutzdemo.module;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.nutz.dao.Cnd;
import org.nutz.dao.Dao;
import org.nutz.dao.QueryResult;
import org.nutz.dao.pager.Pager;
import org.nutz.ioc.loader.annotation.Inject;
import org.nutz.ioc.loader.annotation.IocBean;
import org.nutz.lang.Lang;
import org.nutz.lang.Strings;
import org.nutz.lang.random.R;
import org.nutz.lang.util.NutMap;
import org.nutz.log.Log;
import org.nutz.log.Logs;
import org.nutz.mvc.annotation.At;
import org.nutz.mvc.annotation.Attr;
import org.nutz.mvc.annotation.By;
import org.nutz.mvc.annotation.DELETE;
import org.nutz.mvc.annotation.Filters;
import org.nutz.mvc.annotation.GET;
import org.nutz.mvc.annotation.Ok;
import org.nutz.mvc.annotation.POST;
import org.nutz.mvc.annotation.Param;
import org.nutz.mvc.filter.CheckSession;

import net.wendal.nutzdemo.bean.User;

@Filters(@By(type = CheckSession.class, args = {"me", "/user/login"}))
@Ok("json:{locked:'password|salt'}")
@At("/user")
@IocBean
public class UserModule {

    private static final Log log = Logs.get();

    @Inject
    protected Dao dao;

    @Filters
    @At
    public int count() {
        return dao.count(User.class);
    }

    @Filters
    @GET
    @At({"/login"})
    @Ok("jsp:jsp.user.login")
    public void loginPage() {}

    @GET
    @At({"/", "/index"})
    @Ok("jsp:jsp.user.index")
    public void indexPage() {}

    @Filters
    @POST
    @At
    public NutMap login(String username, String password, HttpSession session) {
        NutMap re = new NutMap("ok", false);
        if (Strings.isBlank(username) || Strings.isBlank(password)) {
            log.debug("username or password is null");
            return re.setv("msg", "用户名或密码不能为空");
        }
        User user = dao.fetch(User.class, username);
        if (user == null) {
            log.debug("no such user = " + username);
            return re.setv("msg", "没有该用户");
        }
        String tmp = Lang.digest("SHA-256", user.getSalt() + password);
        if (!tmp.equals(user.getPassword())) {
            log.debug("password is wrong");
            return re.setv("msg", "密码错误");
        }
        session.setAttribute("me", user);
        return re.setv("ok", true);
    }

    @Filters
    @At
    @Ok(">>:/user/login")
    public void logout(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null)
            session.invalidate();
    }

    @Filters
    @At
    public User me(@Attr("me") User user) {
        return user;
    }

    @At
    public QueryResult list(@Param("..") Pager pager) {
        List<User> users = dao.query(User.class, null, pager);
        pager.setRecordCount(dao.count(User.class));
        QueryResult qr = new QueryResult(users, pager);
        return qr;
    }

//    @POST
//    @At
//    public NutMap add(@Param("..") User user) {
//        NutMap re = new NutMap("ok", false);
//        if (Strings.isBlank(user.getName()))
//            return re.setv("msg", "名字不能是空");
//        if (Strings.isBlank(user.getPassword()))
//            return re.setv("msg", "密码不能是空");
//
//        user.setName(user.getName());
//        user.setAge(user.getAge());
//        user.setSalt(R.UU32());
//        user.setPassword(Lang.digest("SHA-256", user.getSalt() + user.getPassword()));
//
//        dao.insert(user);
//        return re.setv("ok", true);
//    }

    @POST
    @At
    public NutMap add(@Param("..") User user) {
        NutMap re = new NutMap("ok", false);

        String msg = checkUser(user, true);
        if (msg != null){
            return re.setv("ok", false).setv("msg", msg);
        }
        user.setSalt(R.UU32());
        user.setPassword(Lang.digest("SHA-256", user.getSalt() + user.getPassword()));

        dao.insert(user);
        return re.setv("ok", true).setv("data", user);
    }

//    @POST
//    @At
//    public NutMap update(@Param("..") User user) {
//        if (user.getId() > 0)
//            dao.update(user, "age");
//        return new NutMap("ok", user.getId() > 0);
//    }

    @POST
    @At
    public NutMap update(@Param("..")User user) {
        NutMap re = new NutMap();
        if (!Strings.isBlank(user.getName())) {
            return re.setv("ok", false).setv("msg", "用户名不存在");
        }
        User user2 = dao.fetch(User.class, user.getName()); // 根据用户名获取id
        user.setId(user2.getId());
        String msg = checkUser(user, false);
        if (msg != null){
            return re.setv("ok", false).setv("msg", msg);
        }
        user.setName(null);// 不允许更新用户名
        user.setCreateTime(null);//也不允许更新创建时间
        dao.updateIgnoreNull(user);// 真正更新的其实只有password和age
        return re.setv("ok", true);
    }

    @DELETE
    @At("/?")
    public NutMap delete(int userId) {
        if (userId == 1)
            return new NutMap("ok", false);
        return new NutMap("ok", dao.delete(User.class, userId) == 1);
    }

    /**
     * 添加用户校验方法
     * @param user
     * @param create
     * @return
     */
    protected String checkUser(User user, boolean create) {
        if (user == null) {
            return "空对象";
        }
        if (create) {
            if (Strings.isBlank(user.getName()) || Strings.isBlank(user.getPassword()))
                return "用户名/密码不能为空";
        } else {
            if (Strings.isBlank(user.getPassword()))
                return "密码不能为空";
        }
        String passwd = user.getPassword().trim();
        if (6 > passwd.length() || passwd.length() > 12) {
            return "密码长度错误";
        }
        user.setPassword(passwd);
        if (create) {
            int count = dao.count(User.class, Cnd.where("name", "=", user.getName()));
            if (count != 0) {
                return "用户名已经存在";
            }
        } else {
            if (user.getId() < 1) {
                return "用户Id非法";
            }
        }
        if (user.getName() != null)
            user.setName(user.getName().trim());
        return null;
    }
}
