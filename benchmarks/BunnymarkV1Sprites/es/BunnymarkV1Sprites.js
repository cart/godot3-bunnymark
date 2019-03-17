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

/***/ "./src/BunnymarkV1Sprites.ts":
/*!***********************************!*\
  !*** ./src/BunnymarkV1Sprites.ts ***!
  \***********************************/
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
var __values = (this && this.__values) || function (o) {
    var m = typeof Symbol === "function" && o[Symbol.iterator], i = 0;
    if (m) return m.call(o);
    return {
        next: function () {
            if (o && i >= o.length) o = void 0;
            return { value: o && o[i++], done: !o };
        }
    };
};
Object.defineProperty(exports, "__esModule", { value: true });
var BunnymarkV1Sprites = /** @class */ (function (_super) {
    __extends(BunnymarkV1Sprites, _super);
    function BunnymarkV1Sprites() {
        var _this = _super !== null && _super.apply(this, arguments) || this;
        _this.bunnies = [];
        _this.grav = 500;
        _this.bunny_texture = godot.ResourceLoader.load("res://images/godot_bunny.png");
        _this.screen_size = null;
        return _this;
    }
    BunnymarkV1Sprites.prototype._process = function (delta) {
        var e_1, _a;
        this.screen_size = this.get_viewport_rect().size;
        try {
            for (var _b = __values(this.bunnies), _c = _b.next(); !_c.done; _c = _b.next()) {
                var bunny = _c.value;
                var pos = bunny.sprite.position;
                var newPosition = bunny.pos;
                pos.x += newPosition.x * delta;
                pos.y += newPosition.y * delta;
                newPosition.y += this.grav * delta;
                if (pos.x > this.screen_size.x) {
                    newPosition.x *= -1;
                    pos.x = this.screen_size.x;
                }
                if (pos.x < 0) {
                    newPosition.x *= -1;
                    pos.x = 0;
                }
                if (pos.y > this.screen_size.y) {
                    pos.y = this.screen_size.y;
                    if (Math.random() > 0.5)
                        newPosition.y = -(godot.randi() % 1100 + 50);
                    else
                        newPosition.y *= -0.85;
                }
                if (pos.y < 0) {
                    newPosition.y = 0;
                    pos.y = 0;
                }
                bunny.sprite.position = pos;
                bunny.pos = newPosition;
            }
        }
        catch (e_1_1) { e_1 = { error: e_1_1 }; }
        finally {
            try {
                if (_c && !_c.done && (_a = _b.return)) _a.call(_b);
            }
            finally { if (e_1) throw e_1.error; }
        }
    };
    BunnymarkV1Sprites.prototype.add_bunny = function () {
        var bunny = new godot.Sprite();
        bunny.set_texture(this.bunny_texture);
        this.add_child(bunny);
        bunny.position = new godot.Vector2(this.screen_size.x / 2, this.screen_size.y / 2);
        this.bunnies.push({
            sprite: bunny,
            pos: new godot.Vector2(godot.randi() % 200 + 50, godot.randi() % 200 + 50)
        });
    };
    BunnymarkV1Sprites.prototype.remove_bunny = function () {
        if (this.bunnies.length == 0)
            return;
        this.remove_child(this.bunnies.pop().sprite);
    };
    BunnymarkV1Sprites.prototype.finish = function () {
        this.emit_signal("benchmark_finished", this.bunnies.length);
    };
    return BunnymarkV1Sprites;
}(godot.Node2D));
exports.default = BunnymarkV1Sprites;


/***/ }),

/***/ "./src/index.ts":
/*!**********************!*\
  !*** ./src/index.ts ***!
  \**********************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
var BunnymarkV1Sprites_1 = __webpack_require__(/*! ./BunnymarkV1Sprites */ "./src/BunnymarkV1Sprites.ts");
// godot.register_class(BunnymarkV2, "BunnymarkV2");
godot.register_class(BunnymarkV1Sprites_1.default, "BunnymarkV1Sprites");
// godot.register_class(BunnymarkV1DrawTexture, "BunnymarkV1DrawTexture");


/***/ })

/******/ });
//# sourceMappingURL=bundle.js.map