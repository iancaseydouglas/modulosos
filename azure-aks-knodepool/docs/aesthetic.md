# a'la carte-as-Code

Take complexity wherever you find it and simplify ~~simplify,~~ ~~simplify~~.

> ***Be complex, but not complicated.***
>
> ***Be simple, but not simplistic.***

1. **Simplicity First**: The primary interface (`agent_profiles`) is designed to be as simple as possible, allowing users to create node pools with minimal configuration.

2. **Progressive Complexity**: While the basic usage is simple, the module allows for increasing levels of complexity to cater to more advanced use cases.

3. **Separation of Concerns**: All complex logic is contained in `locals.tf`, keeping the main resource definitions clean and readable.

4. **Flexible Configuration**: The module supports a three-tiered configuration approach (defaults, catalog, user overrides), allowing for both ease of use and fine-grained control.

5. **Self-Documenting**: The use of a catalog and menu system makes the available options clear and self-documenting.

6. **Extensibility**: The module is designed to be easily extensible, with clear patterns for adding new features or node pool types.

7. **Consistency**: Automatic naming and tagging ensure consistency across resources.

8. **Intelligent Defaults**: Pre-defined profiles and sensible defaults reduce the cognitive load on users while still allowing for customization.

9. **Escape Hatches**: Advanced configuration options are available for power users who need fine-grained control.

10. **Clear Documentation**: Comprehensive documentation, including examples and guides for extending the module, ensures that users and developers can quickly understand and use the module effectively.

### Bon Appétit!

This design aesthetic aims to provide a balance between ease of use and flexibility, catering to both novice and experienced users while maintaining a clear and consistent interface.


