declare namespace wasm_bindgen {
	/* tslint:disable */
	/* eslint-disable */
	/**
	* @param {string} source
	* @param {object} js_functions
	* @returns {any}
	*/
	export function run(source: string, js_functions: object): any;
	/**
	* @param {string} source
	* @param {object} js_functions
	* @returns {any}
	*/
	export function test(source: string, js_functions: object): any;
	/**
	* @param {string} expression
	* @param {object | undefined} js_functions
	* @returns {any}
	*/
	export function evaluate(expression: string, js_functions?: object): any;
	
}

declare type InitInput = RequestInfo | URL | Response | BufferSource | WebAssembly.Module;

declare interface InitOutput {
  readonly memory: WebAssembly.Memory;
  readonly run: (a: number, b: number, c: number, d: number) => void;
  readonly test: (a: number, b: number, c: number, d: number) => void;
  readonly evaluate: (a: number, b: number, c: number, d: number) => void;
  readonly __wbindgen_export_0: (a: number) => number;
  readonly __wbindgen_export_1: (a: number, b: number, c: number) => number;
  readonly __wbindgen_add_to_stack_pointer: (a: number) => number;
  readonly __wbindgen_export_2: (a: number) => void;
}

/**
* If `module_or_path` is {RequestInfo} or {URL}, makes a request and
* for everything else, calls `WebAssembly.instantiate` directly.
*
* @param {InitInput | Promise<InitInput>} module_or_path
*
* @returns {Promise<InitOutput>}
*/
declare function wasm_bindgen (module_or_path?: InitInput | Promise<InitInput>): Promise<InitOutput>;
