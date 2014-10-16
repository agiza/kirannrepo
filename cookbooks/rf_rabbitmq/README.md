# rf_rabbitmq-cookbook

Install rabbitmq in a clustered fashion

## Supported Platforms

Tested on centos 6

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['rf_rabbitmq']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### rf_rabbitmq::default

Include `rf_rabbitmq` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[rf_rabbitmq::default]"
  ]
}
```

## License and Authors

Author:: Cosmin Vasii (cosmin.vasii@endava.com)
