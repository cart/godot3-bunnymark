/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = "./src/index.ts");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./src/BunnymarkV2.ts":
/*!****************************!*\
  !*** ./src/BunnymarkV2.ts ***!
  \****************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
var BunnymarkV2 = /** @class */ (function (_super) {
    __extends(BunnymarkV2, _super);
    function BunnymarkV2() {
        var _this = _super !== null && _super.apply(this, arguments) || this;
        _this.grav = 500;
        _this.bunny_texture = godot.ResourceLoader.load("res://images/godot_bunny.png");
        _this.bunny_speeds = [];
        _this.label = new godot.Label();
        _this.bunnies = new godot.Node2D();
        _this.screen_size = null;
        return _this;
    }
    BunnymarkV2.prototype._ready = function () {
        this.add_child(this.bunnies);
        this.label.rect_position = new godot.Vector2(0, 20);
        this.add_child(this.label);
    };
    BunnymarkV2.prototype._process = function (delta) {
        this.screen_size = this.get_viewport_rect().size;
        this.label.text = "Bunnies: " + this.bunnies.get_child_count();
        var bunny_children = this.bunnies.get_children();
        for (var i = 0; i < bunny_children.length; i++) {
            var bunny = bunny_children[i];
            var pos = bunny.position;
            var speed = this.bunny_speeds[i];
            pos.x += speed.x * delta;
            pos.y += speed.y * delta;
            speed.y += this.grav * delta;
            if (pos.x > this.screen_size.x) {
                speed.x *= -1;
                pos.x = this.screen_size.x;
            }
            if (pos.x < 0) {
                speed.x *= -1;
                pos.x = 0;
            }
            if (pos.y > this.screen_size.y) {
                pos.y = this.screen_size.y;
                if (Math.random() > 0.5)
                    speed.y = -(godot.randi() % 1100 + 50);
                else
                    speed.y *= -0.85;
            }
            if (pos.y < 0) {
                speed.y = 0;
                pos.y = 0;
            }
            bunny.position = pos;
            this.bunny_speeds[i] = speed;
        }
    };
    BunnymarkV2.prototype.add_bunny = function () {
        var bunny = new godot.Sprite();
        bunny.set_texture(this.bunny_texture);
        this.bunnies.add_child(bunny);
        bunny.position = new godot.Vector2(this.screen_size.x / 2, this.screen_size.y / 2);
        this.bunny_speeds.push(new godot.Vector2(godot.randi() % 200 + 50, godot.randi() % 200 + 50));
    };
    BunnymarkV2.prototype.remove_bunny = function () {
        var child_count = this.bunnies.get_child_count();
        if (child_count == 0)
            return;
        var bunny = this.bunnies.get_child(child_count - 1);
        this.bunny_speeds.pop();
        this.bunnies.remove_child(bunny);
    };
    BunnymarkV2.prototype.finish = function () {
        this.emit_signal("benchmark_finished", this.bunnies.get_child_count());
    };
    return BunnymarkV2;
}(godot.Node2D));
exports.default = BunnymarkV2;


/***/ }),

/***/ "./src/index.ts":
/*!**********************!*\
  !*** ./src/index.ts ***!
  \**********************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var BunnymarkV2_1 = __webpack_require__(/*! ./BunnymarkV2 */ "./src/BunnymarkV2.ts");
godot.register_class(BunnymarkV2_1.default, "BunnymarkV2");


/***/ })

/******/ });
//# sourceMappingURL=bundle.js.map