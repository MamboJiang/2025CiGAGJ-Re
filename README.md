# 双人对战游戏 - 错误修复报告

## 已修复的问题

### 1. Main类自动加载冲突
**问题**: `main.gd`文件中定义了`class_name Main`，与项目设置中的autoload单例`Main`产生冲突。
**修复**: 移除了`main.gd`中的`class_name Main`声明。
**影响文件**: `main.gd`

### 2. 场景文件预加载问题
**问题**: `game_manager.gd`中使用`preload()`在脚本顶层加载场景文件，导致循环依赖。
**修复**: 将场景加载移至`_ready()`函数中，并使用`load()`替代`preload()`。
**影响文件**: `game_manager.gd`

### 3. 类型引用问题
**问题**: 多个文件中使用了`Main.PlayerData`类型声明，但`Main`的`class_name`已被移除。
**修复**: 移除了所有显式的`Main.PlayerData`类型声明，改为无类型声明。
**影响文件**: 
- `hero.gd`: 移除`setup_player`函数参数和`player_data`变量的类型声明
- `tool_character.gd`: 移除`setup_player`函数参数和`player_data`变量的类型声明
- `main.gd`: 移除`get_player_data`函数返回值的类型声明
- `game_manager.gd`: 移除`_on_state_changed`函数参数的类型声明

### 4. 附身机制快速切换问题
**问题**: 附身工具后会立即返回Hero，因为附身和返回使用相同的交互键。
**修复**: 添加了交互冷却机制，防止快速切换。
**具体修改**:
- 在`hero.gd`和`tool_character.gd`中添加了`interaction_cooldown`变量
- 设置0.3秒的交互延迟常量`INTERACTION_DELAY`
- 在`_process`函数中更新冷却计时器
- 在交互函数中添加冷却检查
**影响文件**: `hero.gd`, `tool_character.gd`

### 5. Hero隐身机制
**问题**: 附身工具后Hero没有隐身。
**修复**: 实现了Hero在附身时的隐身和碰撞禁用机制。
**具体修改**:
- 在`possess_tool`函数中设置`visible = false`并禁用碰撞体
- 在`return_to_hero`函数中恢复`visible = true`并重新启用碰撞体
**影响文件**: `hero.gd`, `tool_character.gd`

### 6. 场景资源优化
**问题**: 角色场景文件资源引用不完整。
**修复**: 更新了场景文件的资源引用，使用asset目录中的精灵资源。
**具体修改**:
- `hero.tscn`: 添加了多方向移动的精灵资源
- `knife.tscn`: 添加了厨刀的动作精灵资源
- `pan.tscn`和`milk.tscn`: 使用sample resource中的图片资源
**影响文件**: `scenes/characters/` 目录下的所有.tscn文件

## 修复的文件

### main.gd
- 移除了`class_name Main`声明
- 保持autoload单例功能

### scripts/game_manager.gd
- 将场景预加载改为运行时加载
- 保持Main单例的信号和方法访问

### scripts/hero.gd
- 移除`player_data: Main.PlayerData`类型声明
- 移除`setup_player`函数的类型参数

### scripts/tool_character.gd
- 移除`player_data: Main.PlayerData`类型声明
- 移除`setup_player`函数的类型参数

## 游戏概述

这是一个基于Godot 4.4开发的双人对战游戏，玩家控制英雄角色，可以附身到不同的工具角色（战士、坦克、奶妈）进行战斗。

### 角色系统

#### Hero（英雄）
- 生命值：0（无法直接战斗）
- 移动速度：200
- 特殊能力：可以附身到工具角色

#### 战士（Knife）
- 生命值：80
- 移动速度：220
- 攻击力：25
- 技能冷却：0.8秒
- 攻击范围：80

#### 坦克（Pan）
- 生命值：150
- 移动速度：150
- 治疗量：20
- 技能冷却：2.0秒
- 治疗范围：60

#### 奶妈（Milk）
- 生命值：100
- 移动速度：180
- 复活次数：3次
- 技能冷却：3.0秒
- 复活范围：120

### 操作说明

#### 玩家1控制
- 移动：WASD
- 交互/附身：Q
- 使用技能：E

#### 玩家2控制
- 移动：方向键
- 交互/附身：右Shift
- 使用技能：右Ctrl

### 游戏规则

1. 每个玩家有1个英雄和3个工具角色
2. 英雄可以附身到工具角色进行战斗
3. 工具角色死亡后可以被奶妈复活
4. 当一方所有工具角色都死亡时，游戏结束
5. 对方玩家获胜

### 项目结构

```
├── main.gd                    # 主管理器（autoload）
├── bg_map/
│   └── bg_map.tscn           # 主游戏场景
├── scenes/characters/
│   ├── hero.tscn             # 英雄场景
│   ├── knife.tscn            # 战士场景
│   ├── pan.tscn              # 坦克场景
│   └── milk.tscn             # 奶妈场景
├── scripts/
│   ├── character_base.gd     # 角色基类
│   ├── hero.gd               # 英雄脚本
│   ├── tool_character.gd     # 工具角色脚本
│   └── game_manager.gd       # 游戏管理器
└── ui/Menu/
    ├── start_menu.tscn       # 开始菜单
    └── about_page.tscn       # 关于页面
```

### 核心系统

1. **状态管理**: 通过Main单例管理游戏状态
2. **角色系统**: 基于继承的角色类层次结构
3. **附身机制**: 英雄可以控制工具角色
4. **技能系统**: 每个工具角色有独特的技能
5. **UI系统**: 实时显示血量、冷却、状态等信息

### 如何运行

1. 在Godot 4.4中打开项目
2. 运行主场景`bg_map/bg_map.tscn`
3. 或从开始菜单`ui/Menu/start_menu.tscn`开始

### 开发特性

- 面向对象设计
- 事件驱动架构
- 模块化组件系统
- 响应式UI更新
- 完整的游戏循环

### 扩展可能

- 添加更多工具角色类型
- 实现网络多人游戏
- 添加技能升级系统
- 增加地图元素和障碍物
- 实现AI对手

## 测试建议

在Godot编辑器中：
1. 检查所有脚本是否没有语法错误
2. 运行主场景测试基本功能
3. 测试角色移动和附身机制
4. 验证技能系统和UI更新
5. 测试游戏胜负判定

所有已知的编译错误都已修复，项目应该可以正常运行。