# 学习搭子 · Web 全栈课程实验项目

一个覆盖 **Web 基础 → RESTful → Git/CI → 安全 → LLM 智能原型** 五个实验的完整项目。
后端 Spring Boot 3 + MyBatis，前端 Vue 3 + Vite，附带 GitHub Actions CI 与 PR 模板。

## 技术栈

| 层 | 技术 |
|---|---|
| 后端 | Java 17 · Spring Boot 3.4 · MyBatis · Spring Security · JWT (jjwt) · springdoc-openapi |
| 数据库 | H2（演示，零依赖）· MySQL（`application-mysql.yml` 切换） |
| 前端 | Vue 3 · Vite · Vue Router · Axios |
| 协作 | Git · GitHub Actions · PR 模板 |

## 目录结构

```
backend/                  # 后端（Maven）
  src/main/java/com/example/lab/
    entity/ mapper/ service/ controller/ dto/ common/ config/ security/ llm/
  src/main/resources/
    application.yml        # 默认 H2 + 通用配置
    application-mysql.yml  # 切换 MySQL
    schema.sql / data.sql  # 表结构与种子数据
    mapper/*.xml           # MyBatis SQL
    rag/course.md          # 实验五 RAG 语料
  db/init-mysql.sql        # MySQL 一键初始化脚本
frontend/                  # 前端（Vite）
.github/workflows/ci.yml   # CI
.github/pull_request_template.md
docs/实验五反思.md          # 幻觉案例与应对
```

## 实验映射

- **实验一**：`User` / `UserMapper` / `UserService` / `UserController` 分层 + 用户表 CRUD，`UserServiceTest` 单测。
- **实验二**：`@RestController` RESTful JSON + `WebConfig` CORS + OpenAPI 文档 + `frontend/` Vue 调用。
- **实验三**：`.gitignore`、Git 分支/PR 流程、`.github/workflows/ci.yml`（后端 mvn + 前端 npm）。
- **实验四**：`SecurityConfig` + `JwtService` + `JwtAuthenticationFilter` + RBAC（用户/角色/权限表）+ BCrypt + `@PreAuthorize`。
- **实验五**：`LlmClient`（OpenAI 兼容）+ `VectorEmbedder`/`RagService`（切块→向量化→检索→拼提示）+ `/api/ai/ask` 学习搭子。

## 快速开始

### 1. 运行后端（默认 H2，零依赖）

```bash
cd backend
mvn clean package            # 打包并跑单测
java -jar target/lab-backend-0.0.1-SNAPSHOT.jar
```

- 接口文档：http://localhost:8080/swagger-ui.html
- H2 控制台：http://localhost:8080/h2-console（`jdbc:h2:mem:labdb`，用户 `sa`，空密码）

切换 MySQL：先执行 `backend/db/init-mysql.sql`，再以 `--spring.profiles.active=mysql` 启动，并设置 `MYSQL_USER`/`MYSQL_PASSWORD`。

### 2. 运行前端

```bash
cd frontend
npm install
npm run dev          # http://localhost:5173（开发代理 /api 到 8080）
npm run build        # 生产构建，产物在 dist/
```

### 3. 演示账号

| 账号 | 密码 | 角色 | 权限 |
|---|---|---|---|
| admin | 123456 | ROLE_ADMIN | 全部（含增删改） |
| zhangsan | 123456 | ROLE_USER | 只读 + AI 问答 |

### 4. 实验五 LLM（可选）

默认未配置 API Key，问答接口进入“演示模式”（仅展示 RAG 检索结果）。接入真实大模型：

```bash
export LLM_API_KEY=你的key
export LLM_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1   # 通义，可换文心/Ollama
export LLM_MODEL=qwen-plus
```

## 主要接口

| 方法 | 路径 | 说明 | 权限 |
|---|---|---|---|
| POST | /api/auth/login | 登录，返回 JWT | 公开 |
| GET | /api/users | 用户列表 | user:read |
| POST | /api/users | 新增用户 | user:write |
| PUT | /api/users/{id} | 更新用户 | user:write |
| DELETE | /api/users/{id} | 删除用户 | user:delete |
| POST | /api/ai/ask | 智能问答（RAG） | ai:ask |

## 安全说明

- 密码一律 BCrypt 加密入库，绝不存明文；响应不返回密码字段。
- JWT 无状态鉴权，前端令牌存于内存/localStorage（演示用途），生产建议 HttpOnly Cookie。
- `@PreAuthorize` 按权限点（`user:read`/`user:write`/`user:delete`/`ai:ask`）控制接口。
- 对“用户输入 → 模型”链路做了长度校验 + 提示注入特征拦截（见 `AiController`）。

## Git 协作流程（实验三）

```bash
git checkout -b feature/xxx
# ... 修改 ...
git add . && git commit -m "feat: xxx"
git push origin feature/xxx
# 发起 Pull Request，按 PR 模板填写，等待 Code Review 后 merge
```

CI 在 `.github/workflows/ci.yml`，推送到 `main`/`develop` 或开 PR 时自动执行后端 `mvn package` 与前端 `npm run build`。
