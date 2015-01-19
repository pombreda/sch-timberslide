# sch-timberslide-cookbook

Installs the TimberSlide program.

## Supported Platforms

+ centos
+ Amazon Linux

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['sch-timberslide']['tofu']</tt></td>
    <td>Boolean</td>
    <td>whether to include tofu</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### sch-timberslide::default

Include `sch-timberslide` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[sch-timberslide::default]"
  ]
}
```

## License and Authors

Author:: David F. Severski (<davidski@deadheaven.com>)
